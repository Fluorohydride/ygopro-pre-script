--転生炎獣パイロ・フェニックス
--
--Script by JoyJ
function c101010039.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c101010039.matfilter,2)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010039,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101010039.descon)
	e1:SetTarget(c101010039.destg)
	e1:SetOperation(c101010039.desop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010039,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,101010039)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c101010039.sptg)
	e2:SetOperation(c101010039.spop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101010039,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101010039+100)
	e3:SetTarget(c101010039.damtg)
	e3:SetOperation(c101010039.damop)
	c:RegisterEffect(e3)
end
function c101010039.matfilter(c)
	return c:IsLinkType(TYPE_EFFECT) and c:IsLinkAttribute(ATTRIBUTE_FIRE)
end
function c101010039.descon(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
		and c:GetMaterial():IsExists(Card.IsLinkCode,1,nil,101010039)
end
function c101010039.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101010039.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c101010039.spfilter(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c101010039.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE)
		and c101010039.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c101010039.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	local g = Duel.SelectTarget(tp,c101010039.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,1-tp,LOCATION_GRAVE)
end
function c101010039.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)
	end
end
function c101010039.damtgfilter(c,tp,eg)
	return eg:IsContains(c) and c:IsControler(1-tp)
		and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsType(TYPE_LINK) and c:IsFaceup()
		and c:GetBaseAttack()>0
end
function c101010039.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c101010039.damtgfilter(c,tp,eg) end
	if chk==0 then return Duel.IsExistingTarget(c101010039.damtgfilter,tp,0,LOCATION_MZONE,1,nil,tp,eg) end
	local g = nil
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
		g = eg
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		g = Duel.SelectTarget(tp,c101010039.damtgfilter,tp,0,LOCATION_MZONE,1,1,nil,tp,eg)
	end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,g,0,1-tp,g:GetFirst():GetBaseAttack())
end
function c101010039.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)
end
