--リチュアの氷魔鏡
--
--Script by Trishula9
function c101111066.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101111066.target)
	e1:SetOperation(c101111066.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101111066.tdtg)
	e2:SetOperation(c101111066.tdop)
	c:RegisterEffect(e2)
end
function c101111066.filter(c,e,tp)
	return c:IsSetCard(0x3a)
end
function c101111066.rfilter2(c,e,tp)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsSetCard(0x3a) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c101111066.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetReleaseGroup(1-tp):Filter(Card.IsFaceup,nil)
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c101111066.filter,e,tp,mg1,nil,Card.GetLevel,"Equal")
			or (mg2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsExistingMatchingCard(c101111066.rfilter2,tp,LOCATION_HAND,0,1,nil,e,tp))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101111066.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetReleaseGroup(1-tp):Filter(Card.IsFaceup,nil)
	local g1=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,nil,c101111066.filter,e,tp,mg1,nil,Card.GetLevel,"Equal")
	local g2=nil
	local g=g1
	if mg2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		g2=Duel.GetMatchingGroup(c101111066.rfilter2,tp,LOCATION_HAND,0,nil,e,tp)
		g=g1+g2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		if g1:IsContains(tc) and (not g2 or (g2:IsContains(tc) and not Duel.SelectYesNo(tp,aux.Stringid(101111066,0)))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg2:Select(tp,1,1,nil)
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then
			Duel.SetLP(tp,Duel.GetLP(tp)-tc:GetBaseAttack())
			tc:CompleteProcedure()
		end
	end
end
function c101111066.tdfilter(c)
	return c:IsSetCard(0x3a) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c101111066.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c101111066.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101111066.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and c:IsAbleToDeck() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101111066.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c101111066.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end
