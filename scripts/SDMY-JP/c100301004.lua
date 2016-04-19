--電磁石の戦士マグネット・ベルセリオン
--Verserion the Electromagna Warrior
--Script by mercury233
function c100301004.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c100301004.spcon)
	e1:SetOperation(c100301004.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c100301004.cost)
	e2:SetTarget(c100301004.target)
	e2:SetOperation(c100301004.activate)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c100301004.spcon2)
	e3:SetTarget(c100301004.sptg2)
	e3:SetOperation(c100301004.spop2)
	c:RegisterEffect(e3)
end
function c100301004.rmfilter123(c)
	return c:IsCode(100301001,100301002,100301003) and c:IsAbleToRemoveAsCost()
end
function c100301004.rmfilter23(c)
	return c:IsCode(100301002,100301003) and c:IsAbleToRemoveAsCost()
end
function c100301004.rmfilter1(c,g)
	local mg=g:Clone()
	mg:RemoveCard(c)
	return c:IsCode(100301001) and c:IsAbleToRemoveAsCost()
		and mg:IsExists(c100301004.rmfilter2,1,nil,mg)
end
function c100301004.rmfilter2(c,g)
	local mg=g:Clone()
	mg:RemoveCard(c)
	return c:IsCode(100301002) and c:IsAbleToRemoveAsCost()
		and mg:IsExists(c100301004.rmfilter3,1,nil)
end
function c100301004.rmfilter3(c)
	return c:IsCode(100301003) and c:IsAbleToRemoveAsCost()
end
function c100301004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c100301004.rmfilter123,tp,0x16,0,nil)
	local mg2=Duel.GetMatchingGroup(c100301004.rmfilter123,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return mg:IsExists(c100301004.rmfilter1,1,nil,mg)
		and (ft>0 or mg2:GetCount()>ft)
end
function c100301004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Group.CreateGroup()
	local g1=nil
	local g2=nil
	local g3=nil
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then
		local mg=Duel.GetMatchingGroup(c100301004.rmfilter123,tp,0x16,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g1=mg:FilterSelect(tp,c100301004.rmfilter1,1,1,nil,mg)
		mg:RemoveCard(g1:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g2=mg:FilterSelect(tp,c100301004.rmfilter2,1,1,nil,mg)
		mg:RemoveCard(g2:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g3=mg:FilterSelect(tp,c100301004.rmfilter3,1,1,nil)
	else
		local n=ft*-1+1
		local mg1=Duel.GetMatchingGroup(c100301004.rmfilter123,tp,0x16,0,nil)
		local mg2=Duel.GetMatchingGroup(c100301004.rmfilter123,tp,LOCATION_MZONE,0,nil)
		local mg3=Duel.GetMatchingGroup(c100301004.rmfilter23,tp,LOCATION_MZONE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		if mg3:GetCount()<n then
			g1=mg2:FilterSelect(tp,c100301004.rmfilter1,1,1,nil,mg1)
		else
			g1=mg1:FilterSelect(tp,c100301004.rmfilter1,1,1,nil,mg1)
		end
		mg1:RemoveCard(g1:GetFirst())
		mg2:RemoveCard(g1:GetFirst())
		if g1:GetFirst():IsLocation(LOCATION_MZONE) then n=n-1 end
		local mg4=Duel.GetMatchingGroup(c100301004.rmfilter3,tp,LOCATION_MZONE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		if mg4:GetCount()<n then
			g2=mg2:FilterSelect(tp,c100301004.rmfilter2,1,1,nil,mg1)
		else
			g2=mg1:FilterSelect(tp,c100301004.rmfilter2,1,1,nil,mg1)
		end
		mg1:RemoveCard(g2:GetFirst())
		mg2:RemoveCard(g2:GetFirst())
		if g2:GetFirst():IsLocation(LOCATION_MZONE) then n=n-1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		if n>0 then
			g3=mg2:FilterSelect(tp,c100301004.rmfilter3,1,1,nil)
		else
			g3=mg1:FilterSelect(tp,c100301004.rmfilter3,1,1,nil)
		end
	end
	sg:Merge(g1)
	sg:Merge(g2)
	sg:Merge(g3)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c100301004.costfilter(c)
	return (c:IsSetCard(2066) or c:IsCode(99785935,39256679,11549357)) and c:IsLevelBelow(4) and c:IsAbleToRemoveAsCost()
end
function c100301004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100301004.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100301004.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100301004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100301004.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c100301004.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE)
		or (rp~=tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp)
end
function c100301004.spfilter1(c,e,tp,g)
	local mg=g:Clone()
	mg:RemoveCard(c)
	return c:IsCode(100301001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and mg:IsExists(c100301004.spfilter2,1,nil,e,tp,mg)
end
function c100301004.spfilter2(c,e,tp,g)
	local mg=g:Clone()
	mg:RemoveCard(c)
	return c:IsCode(100301002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and mg:IsExists(c100301004.spfilter3,1,nil,e,tp)
end
function c100301004.spfilter3(c,e,tp)
	return c:IsCode(100301003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100301004.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,LOCATION_REMOVED,0,nil,e)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and mg:IsExists(c100301004.spfilter1,1,nil,e,tp,mg)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=mg:FilterSelect(tp,c100301004.spfilter1,1,1,nil,e,tp,mg)
	mg:RemoveCard(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=mg:FilterSelect(tp,c100301004.spfilter2,1,1,nil,e,tp,mg)
	mg:RemoveCard(g2:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=mg:FilterSelect(tp,c100301004.spfilter3,1,1,nil,e,tp)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,3,0,0)
end
function c100301004.spop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 or Duel.IsPlayerAffectedByEffect(tp,59822133)
		or sg:GetCount()<3 then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
