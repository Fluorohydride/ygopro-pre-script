--大钢琴之七音服·库莉娅
--Script by 奥克斯
function c101112049.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,c101112049.lcheck)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101112049.atkval)
	c:RegisterEffect(e1)
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c101112049.effectfilter)
	c:RegisterEffect(e2)
	--Effect 3 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101112049,0))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c101112049.spcon)
	e4:SetTarget(c101112049.sptg)
	e4:SetOperation(c101112049.spop)
	c:RegisterEffect(e4)
end
function c101112049.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM)
end
function c101112049.atkval(e,c)
	local ct=Duel.GetMatchingGroupCount(aux.AND(Card.IsFaceup,Card.IsType),e:GetHandlerPlayer(),LOCATION_EXTRA,0,nil,TYPE_PENDULUM)
	return ct*100
end
function c101112049.effectfilter(e,ct)
	local lg=e:GetHandler():GetLinkedGroup()
	local te,loc,seq=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TYPE)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_PENDULUM) and bit.band(loc,LOCATION_MZONE)~=0 and bit.extract(e:GetHandler():GetLinkedZone(),seq)~=0
end
function c101112049.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp==1-tp
end
function c101112049.spfilter(c,e,tp)
	return c:IsSetCard(0x162) and (c:GetCurrentScale()+3)%2==0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,tp,zone)
end
function c101112049.tefilter(c)
	return c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and c:GetCurrentScale()%2==0
end
function c101112049.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local g=Duel.GetMatchingGroup(c101112049.spfilter,tp,LOCATION_PZONE,0,nil,e,tp,zone)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101112049.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local g=Duel.GetMatchingGroup(c101112049.spfilter,tp,LOCATION_PZONE,0,nil,e,tp,zone)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)==0 or #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	if #sg==0 or Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)==0 then return end
	if Duel.NegateActivation(ev) and Duel.IsExistingMatchingCard(c101112049.tefilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(101112049,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26237713,0))
		local exg=Duel.SelectMatchingCard(tp,c101112049.tefilter,tp,LOCATION_DECK,0,1,1,nil)
		if #exg==0 then return end
		Duel.SendtoExtraP(exg,nil,REASON_EFFECT)
	end
end