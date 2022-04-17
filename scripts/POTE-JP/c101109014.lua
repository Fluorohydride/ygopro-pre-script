--狱水机·谢伦
function c101109014.initial_effect(c)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101109014,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101109014)
	e1:SetTarget(c101109014.tgtg)
	e1:SetOperation(c101109014.tgop)
	c:RegisterEffect(e1)
	--fusion
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101109014,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,101109014+100)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c101109014.condition)
	e3:SetTarget(c101109014.target)
	e3:SetOperation(c101109014.activate)
	c:RegisterEffect(e3)
end
function c101109014.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c101109014.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.IsExistingMatchingCard(c101109014.tgfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101109014.tgop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c101109014.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
			Duel.DiscardDeck(tp,3,REASON_EFFECT)
		end
	end
end
function c101109014.filter0(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function c101109014.filter1(c,e,tp,m,f,chkf)
	if not (c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	local res=c:CheckFusionMaterial(m,e:GetHandler(),chkf)
	return res
end
function c101109014.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c101109014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(c101109014.filter0,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e)
		local res=Duel.IsExistingMatchingCard(c101109014.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c101109014.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101109014.desfilter(c)
	return c:IsFusionCode(89631139,23995346) and c:IsOnField()
end
function c101109014.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101109014.filter0),tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c101109014.filter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ct=0
	local spchk=0
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c101109014.filter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg,e:GetHandler(),chkf)
			ct=mat1:FilterCount(c101109014.desfilter,nil)
			tc:SetMaterial(mat1)
			if mat1:IsExists(Card.IsFacedown,1,nil) then
				local cg=mat1:Filter(Card.IsFacedown,nil)
				Duel.ConfirmCards(1-tp,cg)
			end
			Duel.SendtoDeck(mat1,nil,0,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			local ct=mat1:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
			if ct>1 then
				Duel.SortDecktop(tp,tp,ct)
				for i=1,ct do
					local mg=Duel.GetDecktopGroup(tp,1)
					Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
				end
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			spchk=1
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,e:GetHandler(),chkf)
			ct=mat2:FilterCount(c101109014.desfilter,nil)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
			spchk=1
		end
		tc:CompleteProcedure()
	end
end
