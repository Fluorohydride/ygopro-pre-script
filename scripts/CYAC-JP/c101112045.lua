--星骑士 星圣商神杖使
--Script by 奥克斯
function c101112045.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	Duel.EnableGlobalFlag(GLOBALFLAG_XMAT_COUNT_LIMIT)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101112045)
	e1:SetCondition(c101112045.thcon)
	e1:SetTarget(c101112045.thtg)
	e1:SetOperation(c101112045.thop)
	c:RegisterEffect(e1)
	--star_knight_summon_effect_copy  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(101112045,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101112045+100)
	e2:SetCost(c101112045.copycost)
	e2:SetTarget(c101112045.copytg)
	e2:SetOperation(c101112045.copyop)
	c:RegisterEffect(e2)   
end
function c101112045.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ)
end 
function c101112045.thfilter(c,e)
	return c:IsSetCard(0x9c,0x53) and c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function c101112045.fselect(g)
	return g:FilterCount(Card.IsSetCard,nil,0x9c)==1 or g:FilterCount(Card.IsSetCard,nil,0x53)==1
end
function c101112045.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c101112045.thfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101112045.thfilter(chkc,e) end
	if chk==0 then return g:CheckSubGroup(c101112045.fselect,1,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,c101112045.fselect,false,1,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101112045.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg==0 then return end
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end  
function c101112045.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c101112045.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x9c,0x53) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()) then return false end
	local te=c.star_knight_summon_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or (tg and tg(e,tp,eg,ep,ev,re,r,rp,0))
end
function c101112045.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
			and Duel.IsExistingMatchingCard(c101112045.efffilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101112045.efffilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local tc=g:GetFirst()
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
	local te=tc.star_knight_summon_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c101112045.copyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
		local te=tc.star_knight_summon_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end