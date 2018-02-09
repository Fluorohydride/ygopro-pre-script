--オルターガイスト・マルチフェイカー
--Altergeist Multifaker
function c101004014.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101004014,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCountLimit(1,101004014)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c101004014.spcon1)
	e2:SetTarget(c101004014.sptg1)
	e2:SetOperation(c101004014.spop1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101004014,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,101004014+100)
	e3:SetCost(c101004014.spcost)
	e3:SetTarget(c101004014.sptg2)
	e3:SetOperation(c101004014.spop2)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(101004014,ACTIVITY_SPSUMMON,c101004014.counterfilter)
	if not c101004014.global_check then
		c101004014.global_check=true
		local ex1=Effect.GlobalEffect()
		ex1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ex1:SetCode(EVENT_CHAINING)
		ex1:SetCondition(c101004014.regcon)
		ex1:SetOperation(c101004014.regop)
		Duel.RegisterEffect(ex1,0)
		local ex2=Effect.GlobalEffect()
		ex2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ex2:SetCode(EVENT_CHAIN_NEGATED)
		ex2:SetCondition(c101004014.regcon)
		ex2:SetOperation(c101004014.regop2)
		Duel.RegisterEffect(ex2,0)
	end
end
function c101004014.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
function c101004014.regop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	c101004014[cid]=true
end
function c101004014.regop2(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	c101004014[cid]=false
end
function c101004014.counterfilter(c)
	return c:IsSetCard(0x103)
end
function c101004014.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	return c101004014[cid] and rp==tp
end
function c101004014.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101004014.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101004014.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101004014,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101004014.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c101004014.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x103)
end
function c101004014.filter(c,e,tp)
	return c:IsSetCard(0x103) and not c:IsCode(101004014) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101004014.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101004014.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101004014.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101004014.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
