--Evil★Twin イージーゲーム
--
--Script by JoyJ
function c100415022.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,100415022+EFFECT_COUNT_CODE_OATH)
	e1:SetDescription(aux.Stringid(100415022,0))
	e1:SetCost(c100415022.cost1)
	e1:SetTarget(c100415022.target1)
	e1:SetOperation(c100415022.activate1)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,100415022+EFFECT_COUNT_CODE_OATH)
	e2:SetDescription(aux.Stringid(100415022,1))
	e2:SetCondition(c100415022.condition2)
	e2:SetCost(c100415022.cost2)
	e2:SetTarget(c100415022.target2)
	e2:SetOperation(c100415022.activate2)
	c:RegisterEffect(e2)
end
function c100415022.tgfilter1(c)
	return c:IsSetCard(0x252,0x253)
		and c:IsFaceup()
end
function c100415022.cfilter1(c,tp)
	return c:IsSetCard(0x252,0x253)
		and (c:IsControler(tp) or c:IsFaceup()) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsExistingTarget(c100415022.tgfilter1,tp,LOCATION_MZONE,0,1,c)
end
function c100415022.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100415022.cfilter1,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c100415022.cfilter1,1,1,nil,tp)
	e:SetLabel(sg:GetFirst():GetBaseAttack())
	Duel.Release(sg,REASON_COST)
end
function c100415022.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)
		and c100415022.tgfilter1(c) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100415022.tgfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100415022.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c100415022.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
end
function c100415022.cfilter2(c,tp)
	return c:IsSetCard(0x252,0x253)
		and (c:IsControler(tp) or c:IsFaceup()) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c100415022.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100415022.cfilter2,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c100415022.cfilter2,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c100415022.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c100415022.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
