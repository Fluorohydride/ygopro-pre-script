--Evil★Twin チャレンジ
--
--Script by JoyJ
function c100415021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100415021.target)
	e1:SetOperation(c100415021.activate)
	c:RegisterEffect(e1)
end
function c100415021.tgfilter(c,e,tp)
	return c:IsSetCard(0x252,0x253)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100415021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and c100415021.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100415021.tgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetMZoneCount(tp)>0 end
	local c=Duel.SelectTarget(tp,c100415021.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100415021.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100415021.linkfilter(c)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0x254)
end
function c100415021.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.GetMZoneCount(tp)<1
		or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g=Duel.GetMatchingGroup(c100415021.linkfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100415021,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.LinkSummon(tp,sg:GetFirst(),nil)
	end
end
