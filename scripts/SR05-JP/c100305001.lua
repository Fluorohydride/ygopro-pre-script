--天空聖騎士アークパーシアス
--Angel Paladin Arch-Parshath
--Scripted by sahim
function c100305001.initial_effect(c)
	--counter
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetCode(EVENT_CHAINING)
	e01:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e01:SetOperation(c100305001.chop1)
	c:RegisterEffect(e01)
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e02:SetCode(EVENT_CHAIN_SOLVED)
	e02:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e02:SetOperation(c100305001.chop2)
	c:RegisterEffect(e02)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100305001,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCondition(c100305001.spcon1)
	e1:SetCost(c100305001.spcost)
	e1:SetTarget(c100305001.sptg)
	e1:SetOperation(c100305001.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetCondition(c100305001.spcon2)
	c:RegisterEffect(e2)
	e01:SetLabelObject(e1)
	e02:SetLabelObject(e1)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100305001,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c100305001.thcon)
	e4:SetTarget(c100305001.thtg)
	e4:SetOperation(c100305001.thop)
	c:RegisterEffect(e4)
end
function c100305001.chop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
function c100305001.chop2(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp or not re:IsActiveType(TYPE_COUNTER) then return end
	e:GetLabelObject():SetLabel(1)
end
function c100305001.spcon1(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetLabel()==1
end
function c100305001.spcon2(e,tp,eg,ep,ev,re,r,rp,chk)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	return dp==tp
end
function c100305001.cfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToRemoveAsCost()
end
function c100305001.mzfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c100305001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(c100305001.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	if chk==0 then return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(c100305001.mzfilter,ct,nil)) end
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=rg:Select(tp,2,2,nil)
	elseif ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=rg:FilterSelect(tp,c100305001.mzfilter,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=rg:Select(tp,1,1,g:GetFirst())
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=rg:FilterSelect(tp,c100305001.mzfilter,2,2,nil)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100305001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100305001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100305001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c100305001.thfilter(c)
	return (c:IsSetCard(0x208) or c:IsCode(18036057,69514125,76925842,12510878) or c:IsType(TYPE_COUNTER)) and c:IsAbleToHand()
end
function c100305001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100305001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100305001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100305001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
