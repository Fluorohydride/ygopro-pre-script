--ふわんだりぃずと怖い海
--Script By JSY1728
function c101106075.initial_effect(c)
	--Activate(Special Summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101106075+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101106075.discon)
	e1:SetTarget(c101106075.distg)
	e1:SetOperation(c101106075.disop)
	c:RegisterEffect(e1)
end
function c101106075.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsFaceup() and not c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c101106075.discon(e,tp,eg,ep,ev,re,r,rp)	
	return tp~=ep and Duel.GetCurrentChain()==0 
		and Duel.IsExistingMatchingCard(c101106075.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101106075.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c101106075.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.SendtoHand(g,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetTargetRange(0,1)
	e1:SetValue(3)
	e1:SetReset(RESET_PHASE_PHASE_END)
	Duel.RegisterEffect(e1,tp)
end