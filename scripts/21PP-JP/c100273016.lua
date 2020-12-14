--德梅特爷爷
function c100273016.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100273016,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,100273016)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c100273016.spcost)
	e1:SetTarget(c100273016.sptg)
	e1:SetOperation(c100273016.spop)
	c:RegisterEffect(e1)
	--destory
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100273016,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DETACH_MATERIAL)
	e2:SetCountLimit(1,100273016)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100273016.descon)
	e2:SetTarget(c100273016.destg)
	e2:SetOperation(c100273016.desop)
	c:RegisterEffect(e2)
end
function c100273016.costfilter(c,tp)
	return c:IsCode(75574498) and c:IsFaceup() and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function c100273016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100273016.costfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local tc = Duel.SelectMatchingCard(tp,c100273016.costfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	tc:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100273016.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and (c:GetAttack()==0 or c:GetDefense()==0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100273016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100273016.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c100273016.spop(e,tp,eg,ep,ev,re,r,rp)
	local max=2
	if Duel.GetMZoneCount(tp)<1 then return end
	if Duel.GetMZoneCount(tp)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then max=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100273016.filter,tp,LOCATION_GRAVE,0,1,max,nil,e,tp)
	for tc in aux.Next(g) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(8)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(ATTRIBUTE_DARK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function c100273016.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_NORMAL) and (r & REASON_COST)==REASON_COST
end
function c100273016.destgfilter(c,eg,e)
	for tc in aux.Next(eg) do
		if tc:IsType(TYPE_XYZ) and tc:IsCanBeEffectTarget(e) and tc:GetPreviousSequence()==c:GetSequence() then
			return true
		end
	end
	return false
end
function c100273016.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local eg2=eg:Filter(Card.IsType,nil,TYPE_NORMAL)
	if chk==0 then return Duel.IsExistingTarget(c100273016.destgfilter,tp,LOCATION_MZONE,0,1,nil,eg2,e)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c100273016.destgfilter,tp,LOCATION_MZONE,0,1,1,nil,eg2,e)
	local fc=g:GetFirst()
	e:SetLabelObject(fc)
	local dmg=fc:GetRank()*300
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectMatchingCard(tp,Card.IsCanBeEffectTarget,tp,0,LOCATION_MZONE,1,1,nil,e)
	g:Merge(g2)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
	Duel.SetOperationInfo(0,CATEGORY_DESTORY,g2,1,0,0)
end
function c100273016.desop(e,tp,eg,ep,ev,re,r,rp)
	local _,g=Duel.GetOperationInfo(0,CATEGORY_DESTORY)
	g:Remove(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		local fc=e:GetLabelObject()
		if fc:IsRelateToEffect(e) then
			local _,_,_,p,dmg=Duel.GetOperationInfo(0,CATEGORY_DAMAGE)
			Duel.Damage(p,dmg,REASON_EFFECT)
		end
	end
end
