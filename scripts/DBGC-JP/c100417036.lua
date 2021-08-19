--复苏吹吸
function c100417036.initial_effect(c)
	aux.AddCodeList(c,100417125)
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100417036+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100417036.con1)
	e1:SetTarget(c100417036.tar1)
	e1:SetOperation(c100417036.op1)
	c:RegisterEffect(e1)
end

function c100417036.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,100417125)
end

function c100417036.filter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c100417036.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c100417036.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end

function c100417036.efilter(c,tp)
	return c:IsType(TYPE_EQUIP) and aux.IsCodeListed(c,100417125) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end

function c100417036.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct>2 then ct=2 end
	if ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100417036.filter1),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		if g:GetCount()>0 then
			local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
			if sg:GetCount()<=0 then return end
			local res=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			local tc=sg:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(LOCATION_REMOVED)
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				tc:RegisterEffect(e1)
				tc=sg:GetNext()
			end
			if res and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
				and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c100417036.efilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) 
				and Duel.SelectYesNo(tp,aux.Stringid(100417036,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100417036,1))
				local eg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100417036.efilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp)
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100417036,2))
				local mg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
				Duel.Equip(tp,eg:GetFirst(),mg:GetFirst())
			end
		end
	end
end