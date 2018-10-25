--レッドローズ・ドラゴン
--Red Rose Dragon
--Scripted by AlphaKretin
function c100411025.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100411025,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCountLimit(1,100411025)
	e1:SetCondition(c100411025.spcon)
	e1:SetTarget(c100411025.sptg)
	e1:SetOperation(c100411025.spop)
	c:RegisterEffect(e1)
end
function c100411025.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c100411025.spfilter(c,e,tp)
	return c:IsSetCard(0x123) and not c:IsCode(100411025) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100411025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100411025.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	local rc=e:GetHandler():GetReasonCard()
	if rc and (rc:IsCode(73580471) or (rc:IsRace(RACE_PLANT) and rc:IsType(TYPE_SYNCHRO))) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c100411025.thfilter(c)
	return c:IsCode(100411026,100411027) and c:IsAbleToHand()
end
function c100411025.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100411025.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and e:GetLabel()==1 
		and Duel.IsExistingMatchingCard(c100411025.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(100411025,1)) then
		local g2=Duel.SelectMatchingCard(tp,c100411025.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g2>0 then
			Duel.SendtoHand(g2,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end
