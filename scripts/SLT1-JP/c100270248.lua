--ホーリーナイトアドベント
--Holy Knight Advent
--LUA by Kohana Sonogami
--
function c100270248.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Optional
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100270248)
	e2:SetTarget(c100270248.target)
	c:RegisterEffect(e2)
end
function c100270248.thfilter(c)
	return c:IsLevel(7) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function c100270248.spfilter(c,e,tp)
	return c:IsLevel(7) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100270248.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingTarget(c100270248.thfilter,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c100270248.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(100270248,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(100270248,1)
		opval[off-1]=2
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c100270248.returntohand)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(c100270248.specialsummon)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
end
function c100270248.returntohand(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectTarget(tp,c100270248.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c100270248.specialsummon(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100270248.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
