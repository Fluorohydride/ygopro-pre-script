--マジシャンズ・ソウルズ

--Scripted by mallu11
function c100423002.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100423002)
	e1:SetCost(c100423002.spcost)
	e1:SetTarget(c100423002.sptg)
	e1:SetOperation(c100423002.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100423102)
	e2:SetCost(c100423002.drcost)
	e2:SetTarget(c100423002.drtg)
	e2:SetOperation(c100423002.drop)
	c:RegisterEffect(e2)
end
function c100423002.cfilter(c)
	return c:IsLevelAbove(6) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGraveAsCost()
end
function c100423002.spfilter(c,e,tp)
	return (c:IsCode(46986414) or c:IsCode(38033121)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100423002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100423002.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100423002.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c100423002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
	local b1=e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=e:GetHandler():IsAbleToGrave()
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		e:SetLabel(0)
	elseif not b1 and b2 then
		e:SetLabel(1)
	elseif b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(100423002,0),aux.Stringid(100423002,1))
		if s==0 then
			e:SetLabel(0)
		end
		if s==1 then
			e:SetLabel(1)
		end
	end
	if e:GetLabel()==0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end
	if e:GetLabel()==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function c100423002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if e:GetLabel()==1 and c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c100423002.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(100423002,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100423002.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c100423002.drfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c100423002.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c100423002.drfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
	local b2=Duel.IsPlayerCanDraw(tp,1)
	local b3=Duel.IsPlayerCanDraw(tp,2)
	local gc=0
	if not b2 then return false end
	if b2 and not b3 then gc=1 end
	if b3 then gc=2 end
	if chk==0 then return b1 and (b2 or b3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100423002.drfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,gc,nil)
	if g:GetCount()>0 then
		e:SetLabel(Duel.SendtoGrave(g,REASON_COST))
	end
end
function c100423002.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function c100423002.drop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()>0 then
		Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
	end
end
