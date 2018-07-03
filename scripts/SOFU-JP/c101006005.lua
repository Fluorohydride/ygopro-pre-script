--転生炎獣Jジャガー
--Salamangreat Jack Jaguar
--Script by dest
function c101006005.initial_effect(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101006005,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101006005)
	e2:SetCondition(c101006005.spcon)
	e2:SetTarget(c101006005.sptg)
	e2:SetOperation(c101006005.spop)
	c:RegisterEffect(e2)
end
function c101006005.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x220) and c:IsType(TYPE_LINK)
end
function c101006005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101006005.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c101006005.tdfilter(c)
	return c:IsSetCard(0x220) and c:IsType(TYPE_MONSTER) and not c:IsCode(101006005) and c:IsAbleToDeck()
end
function c101006005.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101006005.tdfilter(chkc) end
	local g=Duel.GetMatchingGroup(c101006005.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()<=0 then return false end
	local zone=0
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	zone=bit.band(zone,0x1f)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
		and Duel.IsExistingTarget(c101006005.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectTarget(tp,c101006005.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101006005.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and e:GetHandler():IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c101006005.filter,tp,LOCATION_MZONE,0,nil)
		if g:GetCount()<=0 then return end
		local zone=0
		for tc in aux.Next(g) do
			zone=bit.bor(zone,tc:GetLinkedZone(tp))
		end
		zone=bit.band(zone,0x1f)
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
