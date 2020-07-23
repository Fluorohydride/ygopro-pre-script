--電脳堺都－九竜
--
--Script by JustFish
function c101102055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101102055,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101102055+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101102055.target)
	e1:SetOperation(c101102055.activate)
	c:RegisterEffect(e1)
end
function c101102055.tffilter(c,tp)
	return c:IsSetCard(0x124e) and not c:IsType(TYPE_FIELD+TYPE_MONSTER) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c101102055.gtfilter(c)
	return c:IsSetCard(0x124e) and c:IsFaceup()
end
function c101102055.spfilter(c,e,tp)
	return c:IsSetCard(0x24e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c101102055.exfilter1(c)
	return c:IsFacedown() and c:IsType(TYPE_XYZ+TYPE_SYNCHRO+TYPE_FUSION)
end
function c101102055.exfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) or c:IsFacedown() and c:IsType(TYPE_LINK)
end
function c101102055.fselect(g,ft1,ft2,ect,ft)
	return aux.dncheck(g) and #g<=ft and #g<=ect
		and g:FilterCount(c101102055.exfilter1,nil)<=ft1
		and g:FilterCount(c101102055.exfilter2,nil)<=ft2
end
function c101102055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=ft-1 end
		return ft>0 and Duel.IsExistingMatchingCard(c101102055.tffilter,tp,LOCATION_DECK,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)
end
function c101102055.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c101102055.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local gc=Duel.GetMatchingGroupCount(c101102055.gtfilter,tp,LOCATION_ONFIELD,0,nil)
			if gc>=2 and Duel.SelectYesNo(tp,aux.Stringid(101102055,1)) then
				Duel.BreakEffect()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetTargetRange(LOCATION_MZONE,0)
				e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x24e))
				e1:SetValue(200)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
			if gc>=3 and Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.SelectYesNo(tp,aux.Stringid(101102055,2)) then
				Duel.BreakEffect()
				Duel.DiscardDeck(tp,3,REASON_EFFECT)
			end
			if gc==4 and Duel.IsExistingMatchingCard(c101102055.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
				local ft1=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ+TYPE_SYNCHRO+TYPE_FUSION)
				local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM+TYPE_LINK)
				local ft=Duel.GetUsableMZoneCount(tp)
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then
					if ft1>0 then ft1=1 end
					if ft2>0 then ft2=1 end
					if ft>0 then ft=1 end
				end
				local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ft
				if ect>0 and (ft1>0 or ft2>0) and Duel.SelectYesNo(tp,aux.Stringid(101102055,3)) then
					Duel.BreakEffect()
					local sg=Duel.GetMatchingGroup(c101102055.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
					if sg:GetCount()>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local rg=sg:SelectSubGroup(tp,c101102055.fselect,false,1,4,ft1,ft2,ect,ft)
						if rg:GetCount()>0 then
							Duel.SpecialSummon(rg,0,tp,tp,false,false,POS_FACEUP)
						end
					end
				end
			end
		end
	end
end
