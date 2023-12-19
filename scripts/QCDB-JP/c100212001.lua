--究極竜魔導師
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,{23995346,s.matfilter},1,3,s.matfilter4)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetLabel(TYPE_MONSTER)
	e2:SetCondition(s.necon)
	e2:SetTarget(s.netg)
	e2:SetOperation(s.neop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCountLimit(1,id+o)
	e3:SetLabel(TYPE_SPELL)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCountLimit(1,id+o*2)
	e4:SetLabel(TYPE_TRAP)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(s.spcon)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
	if not s.Ultimat_check then
		s.Ultimat_check=true
		_FCheckMixRepGoalCheck=Auxiliary.FCheckMixRepGoalCheck
		function Auxiliary.FCheckMixRepGoalCheck(tp,sg,fc,chkfnf)
			if fc.exgcheck and not fc.exgcheck(tp,sg,fc) then return false end
			return _FCheckMixRepGoalCheck(tp,sg,fc,chkfnf)
		end
	end
end
function s.matfilter(c,fc,sub,mg,sg)
	return c:IsSetCard(0xdd)
end
function s.matfilter2(c,sg,fc)
	return c:IsSetCard(0xcf) and c:IsType(TYPE_RITUAL) and (sg:IsExists(Card.IsFusionCode,1,c,23995346) or sg:IsExists(Card.CheckFusionSubstitute,1,c,fc))
end
function s.matfilter3(c,sg)
	return c:IsSetCard(0xcf) and c:IsType(TYPE_RITUAL) and (sg:IsExists(Card.IsFusionSetCard,3,c,0xdd))
end
function s.matfilter4(c,sg)
	return c:IsSetCard(0xcf) and c:IsType(TYPE_RITUAL)
end
function s.exgcheck(tp,sg,fc)
	return (sg:GetCount()==4 and sg:IsExists(s.matfilter3,1,nil,sg)) or (sg:GetCount()==2 and sg:IsExists(s.matfilter2,1,nil,sg,fc))
end
function s.necon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(e:GetLabel()) and Duel.IsChainNegatable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.neop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousControler(tp) and rp==1-tp
end
function s.spfilter(c,e,tp)
	return (c:IsSetCard(0xcf) and c:IsType(TYPE_RITUAL) or c:IsSetCard(0xdd)) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
			or c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end