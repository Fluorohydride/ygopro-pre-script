--クロス・デバッガー
--
--Script by mercury233
function c101009002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101009002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101009002)
	e1:SetCondition(c101009002.spcon)
	e1:SetTarget(c101009002.sptg)
	e1:SetOperation(c101009002.spop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101009002,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101009002+100)
	e2:SetCondition(c101009002.atkcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101009002.atktg)
	e2:SetOperation(c101009002.atkop)
	c:RegisterEffect(e2)
end
function c101009002.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c101009002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101009002.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c101009002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101009002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c101009002.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,d=d,a end
	e:SetLabelObject(a)
	return a and d and a:IsRelateToBattle() and d:IsRelateToBattle() and a:IsType(TYPE_LINK) and d:IsType(TYPE_LINK)
end
function c101009002.atkfilter(c)
	return c:IsType(TYPE_LINK) and c:IsAttackAbove(0)
end
function c101009002.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101009002.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101009002.atkfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101009002.atkfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c101009002.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=e:GetLabelObject()
	local tc=Duel.GetFirstTarget()
	if a:IsFaceup() and a:IsRelateToBattle() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		a:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		a:RegisterEffect(e2)
	end
end
