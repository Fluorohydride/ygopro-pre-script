--魔鍵召獣－アンシャラボラス
--
--scripted by zerovoros a.k.a faultzone
function c101105036.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,c101105036.mfilter1,c101105036.mfilter2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101105036)
	e1:SetCondition(c101105036.thcon)
	e1:SetTarget(c101105036.thtg)
	e1:SetOperation(c101105036.thop)
	c:RegisterEffect(e1)
	--change position
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DEFCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101105036.postg)
	e2:SetOperation(c101105036.posop)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end
function c101105036.mfilter1(c)
	return c:IsSetCard(0x266)
end
function c101105036.mfilter2(c)
	return c:IsType(TYPE_NORMAL) and not c:IsType(TYPE_TOKEN)
end
function c101105036.thfilter(c)
	return c:IsCode(101105056) and c:IsAbleToHand()
end
function c101105036.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c101105036.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101105036.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c101105036.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c101105036.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101105036.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsType(TYPE_NORMAL) or c:IsSetCard(0x266))
end
function c101105036.posfilter(c,tp)
	if c:IsFaceup() and c:IsAttackPos() and c:IsCanChangePosition() then
		local att=0
		for gc in aux.Next(Duel.GetMatchingGroup(c101105036.atkfilter,tp,LOCATION_GRAVE,0,nil)) do
			att=att|gc:GetAttribute()
		end
		return c:GetAttribute()&att~=0
	end
end
function c101105036.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101105036.posfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101105036.posfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c101105036.posfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function c101105036.posop(e,tp,ev,eg,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsAttackPos() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		if tc:IsPosition(POS_FACEUP_DEFENSE) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetValue(-1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
