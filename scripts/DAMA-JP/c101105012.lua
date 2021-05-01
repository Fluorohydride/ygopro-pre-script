--いくらの軍貫

--scripted by XyleN5967
function c101105012.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101105012+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101105012.sprcon)
	c:RegisterEffect(e1)
	--to hand or special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105012,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101105012+100)
	e2:SetTarget(c101105012.target)
	e2:SetOperation(c101105012.operation)
	c:RegisterEffect(e2)
end
function c101105012.sprfilter(c)
	return c:IsFaceup() and c:IsCode(101105011)
end
function c101105012.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101105012.sprfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101105012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3
		and (g:IsExists(Card.IsAbleToHand,1,nil) or ft>0
		and Duel.IsPlayerCanSpecialSummon(tp) and not Duel.IsPlayerAffectedByEffect(tp,63060238) and not Duel.IsPlayerAffectedByEffect(tp,97148796)) end
end
function c101105012.filter(c,e,tp,ft)
	return c:IsCode(101105011) and (c:IsAbleToHand() or ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c101105012.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,3)
	if #g==3 then
		Duel.ConfirmDecktop(tp,3)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local tg=g:Filter(c101105012.filter,nil,e,tp,ft)
		if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(101105012,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sg=tg:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if tc:IsAbleToHand() and (ft<=0 or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.SelectOption(tp,1190,1152)==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		Duel.ShuffleDeck(tp)
	end
end
