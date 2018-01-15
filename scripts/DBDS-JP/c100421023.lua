-- 空牙団の英雄 ラファール
--Lafarl, Hero of the Skyfang Brigade
function c100421023.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100421023,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,100421023)
	e1:SetTarget(c100421023.thtg)
	e1:SetOperation(c100421023.thop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100421023,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100421024+100)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCost(c100421023.cost)
	e2:SetCondition(c100421023.discon)
	e2:SetTarget(c100421023.distg)
	e2:SetOperation(c100421023.disop)
	c:RegisterEffect(e2)
end
function c100421023.filter(c)
	return c:IsSetCard(0x214) and c:IsType(TYPE_MONSTER)
end
function c100421023.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c100421023.filter,c:GetControler(),LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,ct) end
end
function c100421023.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c100421023.filter,c:GetControler(),LOCATION_MZONE,0,nil)
	if not Duel.IsPlayerCanDiscardDeck(tp,ct) then return end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local add=g:Select(tp,1,1,nil)
		if add:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(add,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,add)
			Duel.ShuffleHand(tp)
		else
			Duel.SendtoGrave(add,REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
	end
end


function c100421023.cfilter(c)
	return c:IsSetCard(0x214) and c:IsDiscardable()
end
function c100421023.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100421023.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c100421023.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c100421023.discon(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c100421023.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c100421023.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
