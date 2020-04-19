--新生代化石竜 スカルガー
--Fossil Dragon Skullgar
--Scripted by: XGlitchy30
function c100266010.initial_effect(c)
	aux.AddCodeList(c,100266011)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_ROCK),c100266010.matfilter,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c100266010.splimit)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100266010,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,100266010)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c100266010.thtg)
	e3:SetOperation(c100266010.thop)
	c:RegisterEffect(e3)
end
function c100266010.matfilter(c,fc)
	return c:IsFusionType(TYPE_MONSTER) and c:GetLevel()>0 and c:IsLevelBelow(4) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(1-fc:GetControler())
end
function c100266010.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x20 or not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c100266010.thfilter(c)
	return c:IsCode(100266011) and c:IsAbleToHand()
end
function c100266010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100266010.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100266010.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100266010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
