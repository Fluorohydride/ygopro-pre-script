--レベル・レジストウォール
--Level Resist Wall
--LUA by Kohana Sonogami and mercury233
function c100273004.initial_effect(c)
	--Activate/Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,100273004+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100273004.target)
	e1:SetOperation(c100273004.activate)
	c:RegisterEffect(e1)
end
function c100273004.tgfilter(c,e,tp,rp,g,ft)
	local lv=c:GetLevel()
	if not ((c:IsReason(REASON_BATTLE) or (rp==tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
		and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsCanBeEffectTarget(e)
		and lv>0) then return false end
	local sg=g:Filter(Card.IsLevelBelow,nil,lv)
	aux.GCheckAdditional=c100273004.gcheck(lv)
	local res=sg:CheckSubGroup(c100273004.fgoal,1,ft,lv)
	aux.GCheckAdditional=nil
	return res
end
function c100273004.gcheck(lv)
	return	function(sg)
				return sg:GetSum(Card.GetLevel)<=lv
			end
end
function c100273004.fgoal(sg,lv)
	return sg:GetSum(Card.GetLevel)==lv
end
function c100273004.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c100273004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(c100273004.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if chkc then return eg:IsContains(chkc) and c100273004.tgfilter(chkc,e,tp,rp,g,ft) end
	if chk==0 then return ft>0 and eg:IsExists(c100273004.tgfilter,1,nil,e,tp,rp,g,ft) end
	local tg
	if #eg==1 then
		tg=eg
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tg=eg:FilterSelect(tp,c100273004.tgfilter,1,1,nil,e,tp,rp,g,ft)
	end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100273004.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(c100273004.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local lv=tc:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.GCheckAdditional=c100273004.gcheck(lv)
	local sg=g:SelectSubGroup(tp,c100273004.fgoal,false,1,ft,lv)
	aux.GCheckAdditional=nil
	if not sg then return end
	local tc=sg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
