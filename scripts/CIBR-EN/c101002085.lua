--Vendread Reunion
--Scripted by Eerie Code
function c101002085.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101002085.cost)
	e1:SetTarget(c101002085.target)
	e1:SetOperation(c101002085.activate)
	c:RegisterEffect(e1)
end
function c101002085.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c101002085.cfilter(c,e,tp,ft,bs)
	if c:IsSetCard(0x106) and c:IsType(TYPE_RITUAL) 
		and not c:IsPublic() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then
		local lv=c:GetLevel()
		local g=Duel.GetMatchingGroup(c101002085.filter,tp,LOCATION_REMOVED,0,nil,e,tp)
		return g:GetCount()>0 and g:IsExists(c101002085.spfilter,1,nil,lv,ft,g,Group.CreateGroup(),bs)
	else return false end
end
function c101002085.filter(c,e,tp)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsSetCard(0x106) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c101002085.spfilter(c,lv,ft,g,sg,bs)
	if ft==0 then return false end
	local sg2=sg:Clone()
	sg2:AddCard(c)
	local nlv=lv-c:GetLevel()
	local g2=g:Clone()
	g2:Remove(Card.IsCode,nil,c:GetCode())
	return nlv>=0 and (nlv==0 or (not bs and g2:IsExists(c101002085.spfilter,1,nil,nlv,ft-1,g2,sg2,bs)))
end
function c101002085.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local bs=Duel.IsPlayerAffectedByEffect(tp,59822133)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
		return Duel.IsExistingMatchingCard(c101002085.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp,ft,bs)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c101002085.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,ft,bs):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	e:SetLabelObject(tc)
	tc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c101002085.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	if not rc or not rc:IsRelateToEffect(e) or not rc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		or not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local bs=Duel.IsPlayerAffectedByEffect(tp,59822133)
	local lv=rc:GetLevel()
	local g=Duel.GetMatchingGroup(c101002085.filter,tp,LOCATION_REMOVED,0,nil,e,tp)
	local sg=Group.CreateGroup()
	while g:GetCount()>0 and ft>0 and lv>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g:FilterSelect(tp,c101002085.spfilter,1,1,nil,lv,ft,g,sg,bs):GetFirst()
		sg:AddCard(sc)
		g:Remove(Card.IsCode,nil,sc:GetCode())
		lv=lv-sc:GetLevel()
		ft=ft-1
	end
	if sg:GetCount()==0 then return end
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)==sg:GetCount() then
		local og=Duel.GetOperatedGroup()
		Duel.ConfirmCards(1-tp,og)
		Duel.BreakEffect()
		if Duel.Release(og,REASON_EFFECT+REASON_RITUAL+REASON_MATERIAL)==og:GetCount() then
			Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		end
	end
end
