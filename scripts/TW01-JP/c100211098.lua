--狱火机 洪流
function c100211098.initial_effect(c)
  c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,1,4,c100211098.lcheck)
	--disable special summon
  local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100211098,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100211098)
	e1:SetCondition(c100211098.discon)
	e1:SetCost(c100211098.discost)
	e1:SetTarget(c100211098.distg)
	e1:SetOperation(c100211098.disop)
	c:RegisterEffect(e1)
  --remove card
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(100211098,1))
  e2:SetCategory(CATEGORY_REMOVE)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_REMOVE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1,100211098+1000)
  e2:SetCondition(c100211098.rmcon)
  e2:SetTarget(c100211098.rmtg)
  e2:SetOperation(c100211098.rmop)
  c:RegisterEffect(e2)
  --when break
  local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100211098,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c100211098.spcon)
	e3:SetTarget(c100211098.sptg)
	e3:SetOperation(c100211098.spop)
	e3:SetCountLimit(1,100211098+1000+1000)
	c:RegisterEffect(e3)
end

function c100211098.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xbb)
end

function c100211098.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c100211098.costfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c100211098.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100211098.costfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c100211098.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c100211098.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c100211098.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end

function c100211098.rmfl(c,tp)
  return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_GRAVE)
end

function c100211098.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100211098.rmfl,1,nil,tp)
end
function c100211098.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c100211098.rmop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
  end
end
function c100211098.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsPreviousLocation(LOCATION_MZONE)
		and rp==1-tp
end
function c100211098.spfilters(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xbb) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100211098.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100211098.spfilters,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100211098.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100211098.spfilters,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
