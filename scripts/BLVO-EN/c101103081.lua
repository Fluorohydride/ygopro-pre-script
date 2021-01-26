--Materiactor Gigadra

--Scripted by mallu11
function c101103081.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103081,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101103081)
	e1:SetCost(c101103081.spcost)
	e1:SetTarget(c101103081.sptg)
	e1:SetOperation(c101103081.spop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c101103081.splimit)
	c:RegisterEffect(e2)
end
function c101103081.costfilter(c,e,tp,normal)
	return c:IsDiscardable() and (not normal or c:IsType(TYPE_NORMAL)) and Duel.IsExistingMatchingCard(c101103081.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp,normal)
end
function c101103081.spfilter(c,e,tp,normal)
	return (normal and c:IsSetCard(0x262) or c:IsLevel(3) and c:IsType(TYPE_NORMAL)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101103081.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	local b1=Duel.IsExistingMatchingCard(c101103081.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp,false)
	local b2=Duel.IsExistingMatchingCard(c101103081.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp,true)
	if chk==0 then return b1 or b2 end
	local g1=Duel.GetMatchingGroup(c101103081.costfilter,tp,LOCATION_HAND,0,nil,e,tp,false)
	local g2=Duel.GetMatchingGroup(c101103081.costfilter,tp,LOCATION_HAND,0,nil,e,tp,true)
	local sg=nil
	if b1 and not b2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		sg=g1:Select(tp,1,1,nil)
	elseif not b1 and b2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		sg=g2:Select(tp,1,1,nil)
	else
		g1:Merge(g2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		sg=g1:Select(tp,1,1,nil)
	end
	if sg:GetFirst():IsType(TYPE_NORMAL) then
		e:SetLabel(100,1)
	else
		e:SetLabel(100,0)
	end
	Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
end
function c101103081.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c101103081.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,false)
	local b2=Duel.IsExistingMatchingCard(c101103081.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,true)
	local check,label=e:GetLabel()
	if chk==0 then
		e:SetLabel(0,0)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		if check==100 then
			return b1 or b2
		else
			return b1
		end
	end
	e:SetLabel(0,label)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c101103081.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local normal=false
	local check,label=e:GetLabel()
	if label==1 then normal=true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101103081.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,normal)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101103081.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ)
end
