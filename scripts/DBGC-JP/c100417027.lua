--遗迹的魔矿战士
function c100417027.initial_effect(c)
	aux.AddCodeList(c,100417125)
	
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100417027)
	e1:SetCondition(c100417027.con1)
	e1:SetTarget(c100417027.tar1)
	e1:SetOperation(c100417027.op1)
	c:RegisterEffect(e1)
	
	--cannot atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c100417027.con2)
	c:RegisterEffect(e2)
	
	--set card
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMING_BATTLE_END)
	e3:SetCountLimit(1,100417027+100)
	e3:SetCondition(c100417027.con3)
	e3:SetTarget(c100417027.tar3)
	e3:SetOperation(c100417027.op3)
	c:RegisterEffect(e3)
	if not c100417027.global_check then
		c100417027.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c100417027.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function c100417027.check(c)
	return c and aux.IsCodeListed(c,100417125) and c:IsFaceup() and c:IsControler(tp)
end

function c100417027.checkop(e,tp,eg,ep,ev,re,r,rp)
	if c100417027.check(Duel.GetAttacker()) or c100417027.check(Duel.GetAttackTarget()) then
		Duel.RegisterFlagEffect(tp,100417027,RESET_PHASE+PHASE_END,0,1) 
		Duel.RegisterFlagEffect(1-tp,100417027,RESET_PHASE+PHASE_END,0,1)
	end
end

function c100417027.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,100417125)
end

function c100417027.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c100417027.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
end

function c100417027.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,100417125)
end

function c100417027.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE and Duel.GetFlagEffect(tp,100417027)>0
end

function c100417027.filter3(c)
	return aux.IsCodeListed(c,100417125) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end

function c100417027.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(c100417027.filter3,tp,LOCATION_DECK,0,1,nil) end
end

function c100417027.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c100417027.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end