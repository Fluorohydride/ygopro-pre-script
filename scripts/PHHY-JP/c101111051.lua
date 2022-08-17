--銀河百式
--
--Script by Trishula9
function c101111051.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101111051+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c101111051.activate)
	c:RegisterEffect(e1)
	--confirm
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101111051+100)
	e2:SetCondition(c101111051.cfcon)
	e2:SetTarget(c101111051.cftg)
	e2:SetOperation(c101111051.cfop)
	c:RegisterEffect(e2)
end
function c101111051.filter(c)
	return c:IsSetCard(0x55,0x7b) and c:IsAbleToGrave()
end
function c101111051.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101111051.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101111051,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c101111051.cfilter(c)
	return c:IsControler(tp) and c:IsCode(93717133)
end
function c101111051.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101111051.cfilter,1,nil)
end
function c101111051.cftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,1-tp,LOCATION_EXTRA,0,1,nil) end
end
function c101111051.spfilter(c,e,tp)
	return c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c101111051.cfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	local g1=g:Filter(Card.IsAbleToRemove,nil,tp,POS_FACEUP)
	local g2=g:Filter(c101111051.spfilter,nil,e,tp)
	local b1=g1:GetCount()>0
	local b2=g2:GetCount()>0
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(101111051,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(101111051,2)
		opval[off-1]=2
		off=off+1
	end
	ops[off]=aux.Stringid(101111051,3)
	opval[off-1]=3
	off=off+1
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g1:Select(tp,1,1,nil)
		if #sg>0 then
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
		Duel.ShuffleExtra(1-tp)
	elseif opval[op]==2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g2:Select(tp,1,1,nil)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.ShuffleExtra(1-tp)
	end 
end