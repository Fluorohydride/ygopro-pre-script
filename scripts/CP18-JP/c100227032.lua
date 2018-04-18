--No.75 惑乱のゴシップ・シャドー
--Number 75: Gossip Shadow of Confusion
--Scripted by Eerie Code
function c100227032.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,3,2,nil,nil,7)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100227032,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c100227032.chcon)
	e1:SetCost(c100227032.chcost)
	e1:SetOperation(c100227032.chop)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100227032,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100227032)
	e2:SetTarget(c100227032.xtg)
	e2:SetOperation(c100227032.xop)
	c:RegisterEffect(e2)
end
c100227032.xyz_number=75
function c100227032.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp~=tp
end
function c100227032.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c100227032.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c100227032.repop)
end
function c100227032.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c100227032.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x48)
end
function c100227032.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100227032.xfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c100227032.xfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100227032.xfilter,tp,LOCATION_MZONE,0,1,1,c)
end
function c100227032.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local mg=c:GetOverlayGroup()
		if #mg>0 then Duel.Overlay(tc,mg) end
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
