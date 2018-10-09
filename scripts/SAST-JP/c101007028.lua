--炎天禍サンバーン
--Sunburn the Sweltering Solar Calamity
--Script by nekrozar
function c101007028.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101007028,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101007028)
	e1:SetCondition(c101007028.spcon)
	e1:SetTarget(c101007028.sptg)
	e1:SetOperation(c101007028.spop)
	c:RegisterEffect(e1)
end
function c101007028.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and bit.band(c:GetPreviousAttributeOnField(),ATTRIBUTE_FIRE)~=0
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)
end
function c101007028.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101007028.cfilter,1,nil,tp)
end
function c101007028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101007028.damfilter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:GetAttack()>0 and c101007028.cfilter(c,tp)
end
function c101007028.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=eg:Filter(c101007028.damfilter,nil,tp)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0
		and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101007028,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local sg=g:Select(tp,1,1,nil)
		Duel.Damage(1-tp,math.ceil(sg:GetFirst():GetAttack()/2),REASON_EFFECT)
	end
end
