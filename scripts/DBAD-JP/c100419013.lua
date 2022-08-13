--ピュアリィ
--Scripted by JoyJ
local s,id,o=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
		local g=Duel.GetDecktopGroup(tp,3)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.tdfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x28c) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if not g or #g<3 then return end
	g=g:Filter(s.tdfilter,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(p,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.SortDecktop(tp,tp,3-#sg)
		for i=1,3-#sg do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
		Duel.ShuffleHand(p)
	else
		Duel.SortDecktop(tp,tp,3)
		for i=1,3 do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
		Duel.ShuffleHand(p)
	end
end
function s.sptgexfilter(c,e,tp,code)
	local sc=e:GetHandler()
	return aux.IsCodeListed(c,code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and c:IsType(TYPE_XYZ) and sc:IsCanBeXyzMaterial(c) and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0
end
function s.sptgfilter(c,e,tp)
	return not c:IsPublic() and Duel.IsExistingMatchingCard(s.sptgexfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sptgfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain(0) or c:IsFacedown() or c:IsControler(1-tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.sptgfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g<1 then return end
	Duel.ConfirmCards(1-tp,g)
	local sc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.sptgexfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sc:GetCode())
	local tc=sg:GetFirst()
	if c:IsImmuneToEffect(e) then return end
	tc:SetMaterial(Group.FromCards(c))
	Duel.Overlay(tc,Group.FromCards(c))
	Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	tc:CompleteProcedure()
	if not g:GetFirst():IsImmuneToEffect(e) then Duel.Overlay(tc,g) end
end