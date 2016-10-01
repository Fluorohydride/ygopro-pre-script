--十二獣タイグリス
--Juunishishi Tigress
--Script by mercury233
function c100911052.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3,c100911052.ovfilter,aux.Stringid(100911052,0),3,c100911052.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100911052.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c100911052.defval)
	c:RegisterEffect(e2)
	--xyz material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100911052,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c100911052.cost)
	e3:SetTarget(c100911052.target)
	e3:SetOperation(c100911052.operation)
	c:RegisterEffect(e3)
end
function c100911052.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1f2) and not c:IsCode(100911052)
end
function c100911052.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100911052)==0 end
	Duel.RegisterFlagEffect(tp,100911052,RESET_PHASE+PHASE_END,0,1)
end
function c100911052.atkfilter(c)
	return c:IsSetCard(0x1f2) and c:GetAttack()>=0
end
function c100911052.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c100911052.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c100911052.deffilter(c)
	return c:IsSetCard(0x1f2) and c:GetDefense()>=0
end
function c100911052.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c100911052.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c100911052.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100911052.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c100911052.filter2(c)
	return c:IsSetCard(0x1f2) and c:IsType(TYPE_MONSTER)
end
function c100911052.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c100911052.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c100911052.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100911052,2))
	Duel.SelectTarget(tp,c100911052.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100911052,3))
	local g=Duel.SelectTarget(tp,c100911052.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c100911052.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g1=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local g2=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Overlay(g1:GetFirst(),g2)
	end
end
