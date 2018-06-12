--魔界劇場「ファンタスティックシアター」
--Abyss Playhouse – Fantastic Theater
--Scripted by ahtelel
function c100409048.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100409048,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,100409048)
	e2:SetCost(c100409048.thcost)
	e2:SetTarget(c100409048.thtg)
	e2:SetOperation(c100409048.thop)
	c:RegisterEffect(e2)
	--change effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100409048.chcon1)
	e3:SetOperation(c100409048.chop1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_ACTIVATING)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,100409148)
	e4:SetCondition(c100409048.chcon2)
	e4:SetOperation(c100409048.chop2)
	c:RegisterEffect(e4)
end
function c100409048.cfilter(c)
	return c:IsSetCard(0x10ec) and c:IsType(TYPE_PENDULUM) and not c:IsPublic()
end
function c100409048.cfilter2(c,tp)
	return c:IsSetCard(0x20ec) and c:IsType(TYPE_SPELL) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c100409048.cfilter3,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c100409048.cfilter3(c,code)
	return c:IsSetCard(0x20ec) and c:IsType(TYPE_SPELL) and not c:IsCode(code) and c:IsAbleToHand()
end
function c100409048.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100409048.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c100409048.cfilter2,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,c100409048.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c100409048.cfilter2,tp,LOCATION_HAND,0,1,1,nil,tp)
	e:SetLabel(g2:GetFirst():GetCode())
	g1:Merge(g2)
	Duel.ConfirmCards(1-tp,g1)
	Duel.ShuffleHand(tp)
end
function c100409048.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100409048.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100409048.cfilter3,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100409048.chcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c100409048.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100409048.chop1(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():RegisterFlagEffect(100409048,RESET_CHAIN,0,1)
end
function c100409048.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10ec) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c100409048.chcon2(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetFlagEffect(100409048)>0
		and Duel.IsExistingMatchingCard(c100409048.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100409048.chop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	return Duel.ChangeChainOperation(ev,c100409048.repop)
end
function c100409048.desfilter(c)
	return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100409048.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,100409048)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c100409048.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
