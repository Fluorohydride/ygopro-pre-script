--芳香园艺
function c101010059.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010059,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,101010059)
	e1:SetCondition(c101010059.tgcon)
	e1:SetTarget(c101010059.tgtg)
	e1:SetOperation(c101010059.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101010059,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,101010059+100)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCondition(c101010059.spcon)
	e4:SetTarget(c101010059.sptg)
	e4:SetOperation(c101010059.spop)
	c:RegisterEffect(e4)
end
function c101010059.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0xc9) and c:IsFaceup()
end
function c101010059.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101010059.cfilter,1,nil,tp)
end
function c101010059.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c101010059.tgop(e,tp,eg,ep,ev,re,r,rp)
	local _,__,___,p,d = Duel.GetOperationInfo(0,CATEGORY_RECOVER)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
function c101010059.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
		and Duel.GetLP(tp) < Duel.GetLP(1-tp)
end
function c101010059.spfilter(c,e,tp)
	return c:IsSetCard(0xc9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010059.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp) > 0
		and Duel.IsExistingMatchingCard(c101010059.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010059.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.GetMZoneCount(tp) > 0 then
		Duel.Hint(HINT_SELECTMSG,HINTMSG_SPSUMMON)
		local g = Duel.SelectMatchingCard(c101010059.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
