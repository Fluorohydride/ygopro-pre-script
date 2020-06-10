--U.A. Locker Room
--Scripted by Sock#3222
function c101102062.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101102062.target)
	e1:SetOperation(c101102062.activate)
	e1:SetCountLimit(1,101102062+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function c101102062.filter(c,e,tp)
	return (c:IsSetCard(0xb2) or c:IsSetCard(0x107)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101102062.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c101102062.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101102062.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101102062.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c101102062.cfilter(c)
    return (c:IsSetCard(0xb2) or c:IsSetCard(0x107)) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c101102062.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
    if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
        local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
        if Duel.Recover(tp,d,REASON_EFFECT)<=0 then return end
        if not Duel.SelectYesNo(tp,aux.Stringid(101102062,0)) then return end
        local g=Duel.SelectMatchingCard(tp,c101102062.cfilter,tp,LOCATION_HAND,0,1,63,nil)
        if g:GetCount()==0 then return end
        Duel.ConfirmCards(1-tp,g)
        local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
        Duel.ShuffleDeck(tp)
        if ct>0 then
            Duel.BreakEffect()
            Duel.Draw(tp,ct,REASON_EFFECT)
        end
    end
end