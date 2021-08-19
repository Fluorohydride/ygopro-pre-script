--Ra'ten, the Heavenly General
--coded by Lyris
function c101105084.initial_effect(c)
	c:EnableReviveLimit()
	--mat=2+ monsters with the same Type
	aux.AddLinkProcedure(c,nil,2,99,aux.TargetEqualFunction(Group.GetClassCount,1,Card.GetLinkRace))
	--Once per turn, during the Standby Phase: You can target 1 face-up monster this card points to; Special Summon 1 Level 4 or lower monster with the same Type as that monster from your hand to your zone this card points to.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(c101105084.target)
	e1:SetOperation(c101105084.operation)
	c:RegisterEffect(e1)
	--At the start of the Battle Phase: You can target 1 card your opponent controls; destroy it. You can only use this effect of "Ra'ten, the Heavenly General" once per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101105084)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetTarget(c101105084.tg)
	e2:SetOperation(c101105084.op)
	c:RegisterEffect(e2)
end
function c101105084.cfilter(c,e,tp,lg)
	return c:IsFaceup() and lg:IsContains(c) and Duel.IsExistingMatchingCard(c101105084.filter,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetRace(),e:GetHandler():GetLinkedZone(tp))
end
function c101105084.chkfilter(c,e,tp,lg,rc)
	return c:IsFaceup() and lg:IsContains(c) and c:GetRace()&rc==rc
end
function c101105084.filter(c,e,tp,rac,zone)
	return c:IsLevelBelow(4) and c:IsRace(rac) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c101105084.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local zone=c:GetLinkedZone(tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101105084.chkfilter(chkc,e,tp,lg,e:GetLabel()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
		and Duel.IsExistingTarget(c101105084.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101105084.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,lg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	e:SetLabel(g:GetFirst():GetRace())
end
function c101105084.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local zone=c:GetLinkedZone(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c101105084.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc:GetRace(),zone):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c101105084.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101105084.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
