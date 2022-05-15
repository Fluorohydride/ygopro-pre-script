--BF－無頼のヴァータ
function c101110001.initial_effect(c)
	aux.AddCodeList(c,9012916)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101110001)
	e1:SetCondition(c101110001.spcon)
	c:RegisterEffect(e1)   
	--speical summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110001,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101110002)
	e2:SetTarget(c101110001.tgtg)
	e2:SetOperation(c101110001.tgop)
	c:RegisterEffect(e2) 
end
function c101110001.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x33) and not c:IsCode(101110001)
end
function c101110001.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c101110001.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c101110001.thfilter(c)
	return c:IsSetCard(0x33) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER)
end
function c101110001.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local clv=c:GetLevel()
	local lv=8-clv
	local g=Duel.GetMatchingGroup(c101110001.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckWithSumEqual(Card.GetLevel,lv,1,99) and Duel.IsExistingMatchingCard(c101110001.sfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101110001.sfilter(c,e,tp,lv,mc)
	return c:IsCode(9012916)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c101110001.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local clv=c:GetLevel()
	local lv=8-clv
	local tg1=Group.CreateGroup()
	tg1:AddCard(c)
	local g=Duel.GetMatchingGroup(c101110001.thfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:SelectWithSumEqual(tp,Card.GetLevel,lv,1,99)
	tg1:Merge(tg)
	if tg1:GetCount()>0 then
		if Duel.SendtoGrave(tg1,nil,REASON_EFFECT)>1 then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local sg=Duel.SelectMatchingCard(tp,c101110001.sfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv,nil)
		  if sg:GetCount()>0 then
			  Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		  end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101110001.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101110001.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK) and c:IsLocation(LOCATION_EXTRA)
end