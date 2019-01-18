--無限起動ゴライアス
--
--Scripted by Justfish
function c100412100.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c100412100.matfilter,1,1)
	c:EnableReviveLimit()
	--Attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100412100,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,100412100)
	e1:SetCondition(c100412100.xyzcon)
	e1:SetTarget(c100412100.xyztg)
	e1:SetOperation(c100412100.xyzop)
	c:RegisterEffect(e1)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetCondition(c100412100.condition)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c100412100.matfilter(c)
	return c:IsLinkSetCard(0x227) and not c:IsLinkType(TYPE_LINK)
end
function c100412100.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c100412100.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c100412100.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100412100.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100412100.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100412100.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c100412100.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c100412100.condition(e)
	return e:GetHandler():GetOriginalRace()==RACE_MACHINE
end
