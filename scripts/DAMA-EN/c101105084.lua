--Ra'ten, the Heavenly General
--coded by Lyris
function c101105084.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,99,c101105084.lcheck)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101105084.target)
	e1:SetOperation(c101105084.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101105084)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101105084.destg)
	e2:SetOperation(c101105084.desop)
	c:RegisterEffect(e2)
end
function c101105084.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==1
end
function c101105084.cfilter(c,e,tp,lg,zone)
	return c:IsFaceup() and lg:IsContains(c)
		and Duel.IsExistingMatchingCard(c101105084.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetRace(),zone)
end
function c101105084.chkfilter(c,e,tp,lg,rc)
	return c:IsFaceup() and lg:IsContains(c) and c:GetRace()&rc==rc
end
function c101105084.spfilter(c,e,tp,rac,zone)
	return c:IsLevelBelow(4) and c:IsRace(rac) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c101105084.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local zone=c:GetLinkedZone(tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101105084.chkfilter(chkc,e,tp,lg,e:GetLabel(),zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
		and Duel.IsExistingTarget(c101105084.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,lg,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101105084.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,lg,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	e:SetLabel(g:GetFirst():GetRace())
end
function c101105084.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local zone=c:GetLinkedZone(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c101105084.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc:GetRace(),zone):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c101105084.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101105084.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
