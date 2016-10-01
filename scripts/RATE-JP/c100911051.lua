--十二獣ブルホーン
--Juunishishi Bullhorn
--Script by mercury233
function c100911051.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c100911051.ovfilter,aux.Stringid(100911051,0),2,c100911051.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100911051.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c100911051.defval)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100911051,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c100911051.cost)
	e3:SetTarget(c100911051.target)
	e3:SetOperation(c100911051.operation)
	c:RegisterEffect(e3)
end
function c100911051.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1f2) and not c:IsCode(100911051)
end
function c100911051.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100911051)==0 end
	Duel.RegisterFlagEffect(tp,100911051,RESET_PHASE+PHASE_END,0,1)
end
function c100911051.atkfilter(c)
	return c:IsSetCard(0x1f2) and c:GetAttack()>=0
end
function c100911051.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c100911051.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c100911051.deffilter(c)
	return c:IsSetCard(0x1f2) and c:GetDefense()>=0
end
function c100911051.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c100911051.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c100911051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100911051.filter(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsSummonableCard() and c:IsAbleToHand()
end
function c100911051.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100911051.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100911051.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100911051.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
