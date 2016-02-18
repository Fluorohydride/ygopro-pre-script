--マジシャン・オブ・ブラック・イリュージョン
--Magician of Black Illusion
--Script by dest
function c100909017.initial_effect(c)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(46986414)
	c:RegisterEffect(e1)
	--spsummon (self)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100909017,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,100909017)
	e2:SetCondition(c100909017.condition1)
	e2:SetTarget(c100909017.target1)
	e2:SetOperation(c100909017.operation1)
	c:RegisterEffect(e2)
	--spsummon (DM)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100909017,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,100909117)
	e3:SetCondition(c100909017.condition2)
	e3:SetTarget(c100909017.target2)
	e3:SetOperation(c100909017.operation2)
	c:RegisterEffect(e3)
end
function c100909017.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and ep==tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c100909017.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100909017.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c100909017.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c100909017.filter(c,e,tp)
	return c:IsCode(46986414) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100909017.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100909017.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100909017.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100909017.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
