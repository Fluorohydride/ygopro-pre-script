--星杯の守護竜
--Star Grail's Protector Dragon
--Script by mercury233
function c101001021.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101001021,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c101001021.condition)
	e1:SetCost(c101001021.cost)
	e1:SetTarget(c101001021.target)
	e1:SetOperation(c101001021.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101001021,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101001021)
	e2:SetCost(c101001021.spcost)
	e2:SetTarget(c101001021.sptg)
	e2:SetOperation(c101001021.spop)
	c:RegisterEffect(e2)
	--
	if not Card.IsLinkState then
		function Card.IsLinkState(c)
			if not c then return false end
			if c:IsType(TYPE_LINK) and c:GetLinkedGroupCount()>0 then return true end
			local g=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
			local lc=g:GetFirst()
			while lc do
				local lg=lc:GetLinkedGroup()
				if lg and lg:IsContains(c) then return true end
				lc=g:GetNext()
			end
			return false
		end
	end
	--
	if not Duel.GetLinkedZone then
		function Duel.GetLinkedZone(p)
			local zone=0
			local g1=Duel.GetMatchingGroup(Card.IsType,p,LOCATION_MZONE,0,nil,TYPE_LINK)
			local lc=g1:GetFirst()
			while lc do
				zone=bit.bor(zone,lc:GetLinkedZone())
				lc=g1:GetNext()
			end
			local g2=Duel.GetMatchingGroup(Card.IsType,p,0,LOCATION_MZONE,nil,TYPE_LINK)
			local lc=g2:GetFirst()
			while lc do
				local zone0=bit.rshift(lc:GetLinkedZone(),16)
				local zone1=bit.lshift(bit.band(lc:GetLinkedZone(),0xffff),16)
				zone=bit.bor(zone,zone0)
				zone=bit.bor(zone,zone1)
				lc=g2:GetNext()
			end
			return zone
		end
	end
end
function c101001021.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsLinkState()
end
function c101001021.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c101001021.filter,1,nil,tp)
		and Duel.IsChainNegatable(ev)
end
function c101001021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101001021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101001021.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c101001021.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c101001021.spfilter(c,e,tp,zone)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c101001021.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=Duel.GetLinkedZone(tp)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101001021.spfilter(chkc,e,tp,zone) end
	if chk==0 then return zone~=0
		and Duel.IsExistingTarget(c101001021.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectTarget(tp,c101001021.spfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,0,0)
end
function c101001021.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
	end
end
