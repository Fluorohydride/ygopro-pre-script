--魔键召兽-安希亚拉波斯
function c101105036.initial_effect(c)
   --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c101105036.ffilter,c101105036.ffilter2,true)
	--fusion success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101105036,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101105036)
	e1:SetCondition(c101105036.thcon)
	e1:SetTarget(c101105036.thtg)
	e1:SetOperation(c101105036.thop)
	c:RegisterEffect(e1)
	--Position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105036,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c101105036.sptg)
	e2:SetOperation(c101105036.spop)
	c:RegisterEffect(e2)
	--Battle remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end
function c101105036.ffilter(c)
	return c:IsFusionSetCard(0x266)
end
function c101105036.ffilter2(c)
	return c:IsFusionType(TYPE_NORMAL) and not c:IsFusionType(TYPE_TOKEN)
end
function c101105036.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c101105036.thfilter(c)
	return c:IsCode(101105056) and c:IsAbleToHand()
end
function c101105036.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101105036.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c101105036.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c101105036.thfilter,tp,LOCATION_GRAVE,0,1,nil) then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101105036.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c101105036.filter(c,tp)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition() and Duel.IsExistingMatchingCard(c101105036.gfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetAttribute())
end
function c101105036.gfilter(c,att)
	return c:IsAttribute(att) and (c:IsType(TYPE_NORMAL) or c:IsSetCard(0x266))
end
function c101105036.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c101105036.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101105036.filter,tp,0,LOCATION_MZONE,1,nil,tp)
		end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUPATTACK)
	local g=Duel.SelectTarget(tp,c101105036.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101105036.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and tc:IsPosition(POS_FACEUP_ATTACK) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end