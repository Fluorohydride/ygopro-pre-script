--サイバネット・ストーム
--Cynet Storm
--Scripted by Eerie Code
--Prototype, requires a core update for full implementation
function c100333022.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLinkState))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--cannot disable summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSummonType,SUMMON_TYPE_LINK))
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100333022,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(c100333022.spcon)
	e5:SetTarget(c100333022.sptg)
	e5:SetOperation(c100333022.spop)
	c:RegisterEffect(e5)
end
function c100333022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>=2000
end
function c100333022.spfilter(c,e,tp)
	return c:IsFacedown() and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100333022.sptp(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100333022.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100333022.spop(e,tp,eg,ep,ev,re,r,rp)
	--prototype, to be replaced with the appropriate core functions
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()==0 or Duel.GetLocationCountFromEx(tp)<1 then return end
	local tc=g:RandomSelect(tp,1):GetFirst()
	if tc then
		Duel.ConfirmCards(PLAYER_ALL,tc)
		if tc:IsType(TYPE_LINK) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
