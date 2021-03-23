--魔鍵召竜－アンドラビムス
--
--scripted by zerovoros a.k.a faultzone
function c101105037.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,c101105037.mfilter1,c101105037.mfilter2)
	--no activation on fusion summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c101105037.lincon)
	e0:SetOperation(c101105037.linop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCondition(c101105037.lincon)
	e1:SetOperation(c101105037.linop2)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101105037.destg)
	e2:SetOperation(c101105037.desop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101105037.drcon)
	e3:SetTarget(c101105037.drtg)
	e3:SetOperation(c101105037.drop)
	c:RegisterEffect(e3)
end
function c101105037.mfilter1(c)
	return c:IsSetCard(0x266) and c:IsType(TYPE_EFFECT)
end
function c101105037.mfilter2(c)
	return c:IsType(TYPE_NORMAL) and not c:IsType(TYPE_TOKEN)
end
function c101105037.lincon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c101105037.linop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then Duel.SetChainLimitTillChainEnd(tp==rp)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(101105037,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c101105037.resetlinop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function c101105037.linop2(e,tp,eg,ep,ev,re,r,rp)
	-- error
	if e:GetHandler():GetFlagEffect(101105037)~=0 then Duel.SetChainLimitTillChainEnd(tp==rp) end
	e:GetHandler():ResetFlagEffect(101105037)
end
function c101105037.resetlinop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(101105037)
	e:Reset()
end
function c101105037.tgfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsType(TYPE_NORMAL) or c:IsSetCard(0x266))
end
function c101105037.desfilter(c,att)
	return c:IsAttribute(att) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c101105037.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101105037.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101105037.tgfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c101105037.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	local g=Duel.GetMatchingGroup(c101105037.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,1-tp,LOCATION_MZONE)
end
function c101105037.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c101105037.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
		if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
	end
end
function c101105037.drfilter(c,tp,att)
	return c:IsPreviousControler(1-tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetAttribute()&att>0
end
function c101105037.drcon(e,tp,eg,ep,ev,re,r,rp)
	local att,mat=0,e:GetHandler():GetMaterial()
	if e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and mat:GetClassCount(Card.GetAttribute)>1 then
		--error
		for tc in ~Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER) do
			att=att|tc:GetAttribute()
		end
		return att>0 and eg:IsExists(c101105037.drfilter,1,nil,tp,att)
	end
end
function c101105037.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,LOCATION_DECK)
end
function c101105037.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
