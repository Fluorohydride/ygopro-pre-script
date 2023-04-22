--BK プロモーター

--Script by Chrono-Genex
function c100428034.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100428034,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100428034)
	e1:SetCondition(c100428034.spcon)
	e1:SetCost(c100428034.cost)
	e1:SetTarget(c100428034.sptg1)
	e1:SetOperation(c100428034.spop1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100428034,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100428034+100)
	e2:SetCost(c100428034.spcost)
	e2:SetTarget(c100428034.sptg2)
	e2:SetOperation(c100428034.spop2)
	c:RegisterEffect(e2)
	--level
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100428034,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,100428034+200)
	e3:SetCost(c100428034.lvcost)
	e3:SetTarget(c100428034.lvtg)
	e3:SetOperation(c100428034.lvop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(100428034,ACTIVITY_SPSUMMON,c100428034.counterfilter)
end
function c100428034.counterfilter(c)
	return c:IsSetCard(0x1084)
end
function c100428034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(100428034,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100428034.splimit)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
end
function c100428034.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x1084)
end
function c100428034.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c100428034.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100428034.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100428034.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable()
		and c100428034.cost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.Release(c,REASON_COST+REASON_RELEASE)
	c100428034.cost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c100428034.spfilter(c,e,tp)
	return c:IsSetCard(0x1084) and not c:IsCode(100428034) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100428034.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c100428034.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100428034.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min(2,(Duel.GetLocationCount(tp,LOCATION_MZONE)))
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(c100428034.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100428034.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and c100428034.cost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	c100428034.cost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c100428034.lvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1084) and c:IsLevelAbove(1)
end
function c100428034.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100428034.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c100428034.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100428034.lvfilter,tp,LOCATION_MZONE,0,nil)
	local sel=0
	local lv=1
	if not g:IsExists(Card.IsLevelAbove,1,nil,2) then
		sel=Duel.SelectOption(tp,aux.Stringid(100428034,3))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(100428034,3),aux.Stringid(100428034,4))
	end
	if sel==1 then
		lv=-1
	end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
