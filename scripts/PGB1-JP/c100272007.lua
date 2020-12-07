--ヨゲンシャ・ゾルガ
--Zolga the Prophet
--LUA by Kohana Sonogami
--
function c100272007.initial_effect(c)
	--Special Summon this card, then look up to 5 cards
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100272007,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100272007)
	e1:SetCondition(c100272007.spcon)
	e1:SetTarget(c100272007.sptg)
	e1:SetOperation(c100272007.spop)
	c:RegisterEffect(e1)
	--Inflict 2000 damage using this card as a Tribute Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100272007,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,100272007+100)
	e2:SetCondition(c100272007.dmcon)
	e2:SetTarget(c100272007.dmtg)
	e2:SetOperation(c100272007.dmop)
	c:RegisterEffect(e2)
end
function c100272007.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_FAIRY)
		and not c:IsCode(100272007)
end
function c100272007.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100272007.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100272007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100272007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		local ct=1
		if g:GetCount()>=5 then ct=Duel.AnnounceNumber(tp,1,2,3,4,5) end
		Duel.ConfirmDecktop(tp,ct)
	end
end
function c100272007.dmcon(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetReasonCard()
	local at=Duel.GetAttacker()
	return e:GetHandler():IsReason(REASON_RELEASE) and not e:GetHandler():IsReason(REASON_EFFECT) and tc:IsType(TYPE_MONSTER) and at==tc
end
function c100272007.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local at=Duel.GetAttacker()
	local tc=e:GetHandler():GetReasonCard()
	if e:GetHandler():IsReason(REASON_RELEASE) and not e:GetHandler():IsReason(REASON_EFFECT) and tc:IsType(TYPE_MONSTER) and at==tc then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,at,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
	end
end
function c100272007.dmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetReasonCard()
	local at=Duel.GetAttacker()
	if not tc:IsReason(REASON_SUMMON) or (not c:IsReason(REASON_RELEASE) or c:IsReason(REASON_EFFECT)) and not at==tc then return end
	if at==tc then 
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,2000,REASON_EFFECT)
		end
	end
end
