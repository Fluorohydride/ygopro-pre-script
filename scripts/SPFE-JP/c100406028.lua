--召喚獣ライディーン
--Raideen the Eidolon Beast
--Script by nekrozar
function c100406028.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,100406026,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),1,true,true)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100406028,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c100406028.settg)
	e1:SetOperation(c100406028.setop)
	c:RegisterEffect(e1)
end
function c100406028.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c100406028.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100406028.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100406028.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c100406028.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c100406028.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
