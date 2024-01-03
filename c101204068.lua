--ブリンクアウト
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsType(TYPE_LINK) and c:IsAbleToExtra()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,tp,LOCATION_GRAVE)
end
function s.mgfilter(c,e,tp,link)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x10000008)==0x10000008 and c:GetReasonCard()==link
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
unction c32441317.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetMaterial()
	local ct=mg:GetCount()
	local sumtype=tc:GetSummonType()
	if Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)~=0 and sumtype==SUMMON_TYPE_SYNCHRO
		and tc:IsLocation(LOCATION_EXTRA) and ct>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and mg:FilterCount(aux.NecroValleyFilter(c32441317.mgfilter),nil,e,tp,tc)==ct
		and Duel.SelectYesNo(tp,aux.Stringid(32441317,0)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
end
