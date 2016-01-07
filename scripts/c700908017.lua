--BF－弔風のデス
--Script by mercury233
function c700908017.initial_effect(c)
	--lv up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(700908017,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,700908017)
	e1:SetTarget(c700908017.target)
	e1:SetOperation(c700908017.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c700908017.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(700908017,3))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c700908017.damcon)
	e4:SetTarget(c700908017.damtg)
	e4:SetOperation(c700908017.damop)
	c:RegisterEffect(e4)
end
function c700908017.filter(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsSetCard(0x33)
end
function c700908017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c700908017.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c700908017.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c700908017.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,550)
	if g:GetFirst():GetLevel()==1 then
		op=Duel.SelectOption(tp,aux.Stringid(700908017,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(700908017,1),aux.Stringid(700908017,2))
	end
	e:SetLabel(op)
end
function c700908017.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else
			e1:SetValue(-1)
		end
		tc:RegisterEffect(e1)
	end
end
function c700908017.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(700908017,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c700908017.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(700908017)>0
end
function c700908017.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1000)
end
function c700908017.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
