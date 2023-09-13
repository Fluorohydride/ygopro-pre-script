--折々の紙神
--Oriori no Kamigami
--Scripted by Larry126, salix5
local s,id,o=GetID()
function s.initial_effect(c)
	--Toss a coin and draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	--Double ATK for each head
	--code changed into id+2*o to avoid bugs
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+id+2*o)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
	--Raise a custom event when coin tossing is detected
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TOSS_COIN)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(s.coinop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.countcon)
	e4:SetOperation(s.countop)
	c:RegisterEffect(e4)
end
s.toss_coin=true
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,0)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local heads=0
	while Duel.TossCoin(tp,1)==1 do
		heads=heads+1
	end
	if heads>=2 then
		Duel.Draw(tp,heads//2,REASON_EFFECT)
	end
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	if ev==0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local atk=c:GetAttack()
		--prevent overflow
		for i=1,ev do
			if atk<<1 <= 0x7fffffff then
				atk=atk<<1
			else
				break
			end
		end
		--Double this card's ATK for each heads
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function s.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res={Duel.GetCoinResult()}
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	for _,coin in ipairs(res) do
		if coin==1 then
			c:RegisterFlagEffect(id+o,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
function s.countcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.countop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local heads_ct=c:GetFlagEffect(id+o)
	c:ResetFlagEffect(id)
	c:ResetFlagEffect(id+o)
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+id+2*o,re,r,rp,ep,heads_ct)
end
