--No.76 諧調光師グラディエール
--
--Scripted by 龙骑
function c100248032.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2)
	c:EnableReviveLimit()
	--Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100248032.attval)
	c:RegisterEffect(e1)
	--indes battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c100248032.indval1)
	c:RegisterEffect(e2)
	--indes effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c100248032.indval2)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,100248032)
	e4:SetTarget(c100248032.xyztg)
	e4:SetOperation(c100248032.xyzop)
	c:RegisterEffect(e4)
end
function c100248032.effilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c100248032.attval(e,c)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local wg=og:Filter(c100248032.effilter,nil)
	local wbc=wg:GetFirst()
	local att=0
	while wbc do
		att=att|wbc:GetAttribute()
		wbc=wg:GetNext()
	end
	return att
end
function c100248032.indval1(e,c)
	return not c:GetBattleTarget():GetAttribute()~=c:GetAttribute()
end
function c100248032.indval2(e,te,rp)
	return rp==1-e:GetHandlerPlayer() and te:IsActivated() and te:GetHandler():GetAttribute()&e:GetHandler():GetAttribute()~=0
end
function c100248032.xyzfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c100248032.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c100248032.xyzfilter,tp,0,LOCATION_GRAVE,1,nil) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c100248032.xyzfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c100248032.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
