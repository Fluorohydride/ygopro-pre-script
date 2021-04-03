--軍貫処『海せん』
--
--scripted by FaultZone
function c101105058.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--deck top
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c101105058.dtcon)
	e1:SetTarget(c101105058.dttg)
	e1:SetOperation(c101105058.dtop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101105058.xyzcon)
	e3:SetOperation(c101105058.xyzop)
	c:RegisterEffect(e3)
end
function c101105058.dtfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x267) and c:IsSummonPlayer(tp)
end
function c101105058.dtcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101105058.dtfilter,1,nil,tp)
end
function c101105058.dttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x267) end
end
function c101105058.dtop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101105058,2))
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x267)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
function c101105058.filter(c,tp)
	return c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp and c:IsSetCard(0x267) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c101105058.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101105058.filter,1,nil,tp)
end
function c101105058.spfilter(c,e,tp)
	return c:IsCode(101105011) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101105058.xyzfilter(c,e,tp)
	return c:IsSetCard(0x267) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)
end
function c101105058.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local def=0
	for tc in aux.Next(eg) do
		if tc:GetPreviousDefenseOnField()<0 then def=0 end
		def=def+tc:GetPreviousDefenseOnField()
	end
	Duel.PayLPCost(1-tp,def)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101105058.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c101105058.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(101105058,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local hc=Duel.SelectMatchingCard(tp,c101105058.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if Duel.SpecialSummon(hc,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyzg=Duel.SelectMatchingCard(tp,c101105058.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			local sc=xyzg:GetFirst()
			if sc then
				Duel.Overlay(sc,hc)
				if Duel.SpecialSummonStep(sc,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP) then
					sc:SetMaterial(hc)
				end
				Duel.SpecialSummonComplete()
				sc:CompleteProcedure()
			end
		end
	end
end
