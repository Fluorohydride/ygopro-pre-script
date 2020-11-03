--鎧竜の聖騎士
--
--"LUA BY REIKAI"
function c101103037.initial_effect(c)
	c:EnableReviveLimit()
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103037,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCountLimit(1,1101103037)
	e1:SetCondition(c101103037.tdcon)
	e1:SetTarget(c101103037.tdtg)
	e1:SetOperation(c101103037.tdop)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103037,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c101103037.cost)
	e2:SetCountLimit(1,101103037)
	e2:SetTarget(c101103037.target)
	e2:SetOperation(c101103037.activate)
	c:RegisterEffect(e2)	 
end
function c101103037.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL) and bc:GetSummonLocation()==LOCATION_EXTRA 
end
function c101103037.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,bc,1,0,0)
end
function c101103037.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local bc=c:GetBattleTarget()
	if not bc:IsRelateToBattle() then return false end
	Duel.SendtoDeck(bc,nil,2,REASON_EFFECT)
end
function c101103037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c101103037.filter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:GetLevel()>=5 and c:IsAttribute(ATTRIBUTE_WIND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101103037.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101103037.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c101103037.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101103037.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
